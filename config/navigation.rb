# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    primary.item :create_holiday, 'Create holiday', root_path
    primary.item :calendar_link, 'Calendar', "/calendar/show"
    primary.item :management_area_link, "Manage holidays", "/administer",
                 if: Proc.new{current_user.user_type_id.eql?(UserTypeConstants::USER_TYPE_MANAGER)}
    primary.item :user_day_link, "Manage holiday allowance", user_days_path,
                 if: Proc.new{current_user.user_type_id.eql?(UserTypeConstants::USER_TYPE_MANAGER)}
    primary.item :invite_link, 'Invite users', new_user_invitation_path,
                 if: Proc.new{current_user.user_type_id.eql?(UserTypeConstants::USER_TYPE_MANAGER)}
   # primary.item :settings_link, "Settings", user_settings_path
    primary.item :reports_link, 'View Reports', reports_path,
                 if: Proc.new{current_user.user_type_id.eql?(UserTypeConstants::USER_TYPE_MANAGER)}
    # primary.item :issues_link, "Report issue", "https://github.com/etskelly/holiday_machine/issues", :class => 'blank_target'
  end

end
