module ApplicationHelper
  def initials(user)
    (user[:name][0] + user[:surname][0]).upcase
  end
end
