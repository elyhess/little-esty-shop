require 'rails_helper'

describe ApplicationController do

  describe "#cart" do
    it "returns instance of cart" do
      expect(subject.cart).to be_an_instance_of(Cart)
    end
  end

end