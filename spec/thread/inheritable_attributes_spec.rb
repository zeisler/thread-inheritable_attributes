require "thread/inheritable_attributes"

RSpec.describe Thread do
  after { Thread.current[:inheritable_attributes] = nil }
  describe ".new" do
    context "when inheritable_attributes is nil" do
      before { Thread.current[:inheritable_attributes] = nil }
      it "returns an empty hash when accessed" do

        thread = Thread.new {
          [Thread.current.__id__, Thread.current[:inheritable_attributes]]
        }
        thread.join
        expect(thread.value).to eq [thread.__id__, {}]
      end
    end

    context "when inheritable_attributes has a value" do
      before { Thread.current[:inheritable_attributes] = { :rory_request_id => SecureRandom.uuid } }
      it "copies inheritable_attributes when creating a new thread" do

        thread = Thread.new {
          [Thread.current.__id__, Thread.current[:inheritable_attributes]]
        }
        thread.join
        expect(thread.value).to eq [thread.__id__, Thread.current[:inheritable_attributes]]
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
      before { Thread.current[:inheritable_attributes] = { my_found_key: "here i am" } }
      it "returns the hash value" do
        expect(Thread.current.get_inheritable_attribute(:my_found_key)).to eq "here i am"
      end
    end
  end

  describe "#set_inheritable_attribute" do
    it "sets a value to a key" do
      Thread.current.set_inheritable_attribute(:key_thing, :value_thing)
      expect(Thread.current[:inheritable_attributes]).to eq({ :key_thing => :value_thing })
    end
  end
end
