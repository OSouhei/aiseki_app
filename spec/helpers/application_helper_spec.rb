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

  describe "#replace_flash_class" do
    context "with expected argument" do
      it "returns replaced class name" do
        expect(replace_flash_class("notice")).to eq "alert alert-success"
        expect(replace_flash_class("alert")).to eq "alert alert-warning"
        expect(replace_flash_class("error")).to eq "alert alert-danger"
      end
    end

    context "with unexpected argument" do
      it "returns nil" do
        expect(replace_flash_class("foo")).to eq nil
        expect(replace_flash_class(1)).to eq nil
      end
    end

    context "with empty argument" do
      it "returns nil" do
        expect(replace_flash_class("   ")).to eq nil
      end
    end

    context "with nil argument" do
      it "returns nil" do
        expect(replace_flash_class(nil)).to eq nil
      end
    end
  end
end
