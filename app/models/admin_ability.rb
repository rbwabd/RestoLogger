class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= AdminUser.new       

    can :manage, :all
    
    #case user.role      
    #  when "admin"
    #
    #  when "editor"
    #    can :manage, Post   
    #    cannot [:destroy,:edit], Post   
    #  end
  end 
end  