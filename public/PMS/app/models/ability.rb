class Ability
  include CanCan::Ability

  def initialize(user)
    puts user.email
    puts user.role
    puts user.write_privileges
    arr = []
    user.write_privileges.each do |e|
        arr << Object.const_get(e)
    end
    arr1 = []
    user.create_privileges.each do |e|
        arr1 << Object.const_get(e)
    end
    puts arr1
    arr2 = []
    user.delete_privileges.each do |e|
        arr2 << Object.const_get(e)
    end
    puts arr2
    arr4 = []
     user.read_privileges.each do |e|
        arr4 << Object.const_get(e)
    end
    can :access, :rails_admin       # only allow admin users to access Rails Admin
    can :manage, :dashboard
    puts if user.role.to_s == "super_admin"
    puts if user.role.to_s == "admin"
    if user.role.to_s == "super_admin"
        puts "i am in super_admin"
                
      can :manage, :all
    elsif user.role.to_s == "admin"
        puts "i am in admin"
          
         can :read, arr4
         can :update, arr
         can :create, arr1
         can :destroy, arr2
        
    elsif user.role.to_s == "employee"
        puts 'i am in employee'      # only allow admin users to access Rails Admin
        # can :read, :all
        can :update, Project
        can :update, Task
        #can :dashboard ,:all
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
