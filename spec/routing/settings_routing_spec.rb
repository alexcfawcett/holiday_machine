require "spec_helper"

describe SettingsController do
  describe "routing" do

    it "recognizes and generates #index" do
      expect({ get: "/settings" }).to route_to(controller: "settings", action: "index")
    end

    it "recognizes and generates #new" do
      expect({ get: "/settings/new" }).to route_to(controller: "settings", action: "new")
    end

    it "recognizes and generates #show" do
      expect({ get: "/settings/1" }).to route_to(controller: "settings", action: "show", id: "1")
    end

    it "recognizes and generates #edit" do
      expect({ get: "/settings/1/edit" }).to route_to(controller: "settings", action: "edit", id: "1")
    end

    it "recognizes and generates #create" do
      expect({ post: "/settings" }).to route_to(controller: "settings", action: "create")
    end

    it "recognizes and generates #update" do
      expect({ put: "/settings/1" }).to route_to(controller: "settings", action: "update", id: "1")
    end

    it "recognizes and generates #destroy" do
      expect({ delete: "/settings/1" }).to route_to(controller: "settings", action: "destroy", id: "1")
    end

  end
end
