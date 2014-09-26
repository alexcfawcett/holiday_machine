def full_title(page_title)
  base_title = "Holiday Thyme"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in(user)
  visit sign_in_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def set_user_password_in_edit_page(old_password, new_password)
  fill_in "New password", with: new_password
  fill_in "New password confirmation", with: new_password
  fill_in "Current password", with: old_password
  click_button 'Save changes'
end
