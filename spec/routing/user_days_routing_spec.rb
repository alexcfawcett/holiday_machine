require "spec_helper"

describe UserDaysController do
  describe "routing" do

    it "recognizes and generates #index" do
      expect({ get: "/user_days" }).to route_to(controller: "user_days", action: "index")
    end

    it "recognizes and generates #new" do
      expect({ get: "/user_days/new" }).to route_to(controller: "user_days", action: "new")
    end

    it "recognizes and generates #show" do
      expect({ get: "/user_days/1" }).to route_to(controller: "user_days", action: "show", id: "1")
    end

    it "recognizes and generates #edit" do
      expect({ get: "/user_days/1/edit" }).to route_to(controller: "user_days", action: "edit", id: "1")
    end

    it "recognizes and generates #create" do
      expect({ post: "/user_days" }).to route_to(controller: "user_days", action: "create")
    end

    it "recognizes and generates #update" do
      expect({ put: "/user_days/1" }).to route_to(controller: "user_days", action: "update", id: "1")
    end

    it "recognizes and generates #destroy" do
      expect({ delete: "/user_days/1" }).to route_to(controller: "user_days", action: "destroy", id: "1")
    end

  end
end
