require "thread/inheritable_attributes"
require 'securerandom'

RSpec.describe Thread do
  after { Thread.current.send(:store)[:inheritable_attributes] = nil }
  describe ".new" do
    context "when inheritable_attributes is nil" do
      before { Thread.current.send(:store)[:inheritable_attributes] = nil }
      it "returns an empty hash when accessed" do

        thread = Thread.new {
          [Thread.current.__id__, Thread.current.send(:store)[:inheritable_attributes]]
        }
        thread.join
        expect(thread.value).to eq [thread.__id__, {}]
      end
    end

    context "when inheritable_attributes has a value" do
      before { Thread.current.send(:store)[:inheritable_attributes] = { :rory_request_id => SecureRandom.uuid } }
      it "copies inheritable_attributes when creating a new thread" do

        thread = Thread.new {
          [Thread.current.__id__, Thread.current.send(:inheritable_attributes)]
        }
        thread.join
        expect(thread.value).to eq [thread.__id__, Thread.current.send(:inheritable_attributes)]
      end
    end

    it "any args given are passed to the block" do
      arr     = []
      a, b, c = 1, 2, 3
      Thread.new(a, b, c) { |d, e, f| arr << d << e << f }.join
      expect(arr).to eq [1, 2, 3]
    end
  end

  describe "#get_inheritable_attribute" do
    context "for an unknown key" do
      it "returns nil" do
        expect(Thread.current.get_inheritable_attribute(:my_not_found_key)).to eq nil
      end
    end


    context "for a known key" do
      before { Thread.current.send(:store)[:inheritable_attributes] = { my_found_key: "here i am" } }
      it "returns the hash value" do
        expect(Thread.current.get_inheritable_attribute(:my_found_key)).to eq "here i am"
      end
    end
  end

  describe "#set_inheritable_attribute" do
    it "sets a value to a key" do
      Thread.current.set_inheritable_attribute(:key_thing, :value_thing)
      expect(Thread.current.send(:store)[:inheritable_attributes]).to eq({ :key_thing => :value_thing })
    end
  end

  context "when state is changed from child thread" do
    it "does not effect the state in the parent thread" do
      Thread.current.set_inheritable_attribute(:test_value, :i_was_set_in_the_parent)
      thread = Thread.new {
        Thread.current.set_inheritable_attribute(:test_value, :i_was_set_in_the_child)
        [Thread.current.__id__, Thread.current.get_inheritable_attribute(:test_value)]
      }
      thread.join
      expect(thread.value).to eq [thread.__id__, :i_was_set_in_the_child]
      expect(Thread.current.get_inheritable_attribute(:test_value)).to eq :i_was_set_in_the_parent
    end
  end

  context "when state is set from parent thread" do
    it "is accessible in the child thread" do
      Thread.current.set_inheritable_attribute(:test_value, :set_in_parent_after_child_init)
      thread = Thread.new {
        Thread.current.get_inheritable_attribute(:test_value)
      }
      thread.join
      expect(thread.value).to eq :set_in_parent_after_child_init
    end
  end

  context "when using RequestStore" do
    it "can reset all state in a thread" do
      thread = Thread.new {
        Thread.current.set_inheritable_attribute(:test_value, :request_state)
        RequestStore.clear!
        Thread.current.get_inheritable_attribute(:test_value)
      }
      thread.join
      expect(thread.value).to eq nil
    end

    it "only clears out the root thread any nested threads remain with their given state" do
      # Example case when a multi-threaded web server starts up a worker.
      # This logic represent what would happen in a request if a new thread was created.
      thread = Thread.new do
        # Set a variable at the start of the request
        Thread.current.set_inheritable_attribute(:test_value, :request_state_from_root_thread)

        # create new thread inside of request
        child_thread = Thread.new {
          # The var should always be accessible for the life of this new thread
          Thread.current.get_inheritable_attribute(:test_value)
        }
        # At the end of the request clear the state.
        RequestStore.clear!
        # The new thread does not have to be joined before the request has ended
        child_thread.join
        # Return the child thread value to ensure that even after the state is cleared in the request thread
        # the child still holds on to a copy at the time it was created.
        child_thread.value
      end
      thread.join
      expect(thread.value).to eq :request_state_from_root_thread
    end
  end
end
