require "thread_variable_cascade/thread"

RSpec.describe Thread do
  after { Thread.current[:inheritable_attributes] = nil }
  describe ".new" do
    context "when inheritable_attributes is nil" do
      before { Thread.current[:inheritable_attributes] = nil }
      it "when creating a new thread it copies inheritable_attributes" do

        thread = Thread.new {
          [Thread.current.__id__, Thread.current[:inheritable_attributes]]
        }
        thread.join
        expect(thread.value).to eq [thread.__id__, {}]
      end
    end

    context "when inheritable_attributes has a value" do
      before { Thread.current[:inheritable_attributes] = {:rory_request_id => SecureRandom.uuid} }
      it "when creating a new thread it copies inheritable_attributes" do

        thread = Thread.new {
          [Thread.current.__id__, Thread.current[:inheritable_attributes]]
        }
        thread.join
        expect(thread.value).to eq [thread.__id__, Thread.current[:inheritable_attributes]]
      end
    end
  end

  describe "#inheritable_attributes" do
    it "defaults to a Hash" do
      expect(Thread.current.inheritable_attributes).to be_an_instance_of(Hash)
    end
  end

  describe "#inheritable_attributes=" do
    it "defaults to a Hash" do
      Thread.current.inheritable_attributes = "hello"
      expect(Thread.current.inheritable_attributes).to eq "hello"
    end
  end
end
