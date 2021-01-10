require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe "#full_title" do
    base_title = "相席app"

    context "when page title is blank" do
      it "returns only base_title when argument is empty" do
        expect(full_title).to eq base_title
      end

      it "returns only base_title when page_title is nil" do
        expect(full_title("")).to eq base_title
      end

      it "returns only base_title when page_title is blank" do
        expect(full_title("   ")).to eq base_title
      end
    end

    context "when page title is not blank" do
      it "returns full_title" do
        expect(full_title("about")).to eq "about - #{base_title}"
        expect(full_title("help")).to eq "help - #{base_title}"
      end
    end
  end
end
