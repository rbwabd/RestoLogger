class Ability
  include CanCan::Ability

  #example codes
  # @bags = Bag.accessible_by(current_ability)  to access only the items visible by current ability
  # user classesadmin moderator owner banned
  
  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role? :banned
      cannot :manage, :all
    elsif user.role? :admin
      can :manage, :all
    else #basically normal users without special rights
      can :read, Visit do |visit|
        visit.try(:user) == user
      end
      can :create, Visit
      # update on visit updates the items ordered, while update_parameters changes the ratings, review text, pictures etc.
      can [:update, :destroy, :edit_parameters, :update_parameters], Visit do |visit|
        visit.try(:user) == user
      end
      
      can :destroy, DishReview do |dish_review|
        dish_review.try(:user) == user
      end

      can :read, Store
      can [:create, :update], Store
      can :destroy, Store do |store|
        store.try(:user) == user
      end
      can :search, :stores                    # two non-RESTful actions that allow user to search for a store
      
      can :show, Menu
      can [:add, :confirm, :save], Menu       # add new items to menu
      can [:edit_order, :update_order], Menu   # change order which menu items and categories are presented
    
      can :show, Dish
      can :destroy, Dish do |dish|
        dish.try(:user) == user
      end
      
      can :read, Authentication
      can :destroy, Authentication do |authentication|
        authentication.try(:user) == user
      end
      
      can :read, User do |u|
        # u.try(:friend?, user)  #verify u and user are friends
      end
      can :update, User do |u|
        u == user
      end
    end
  end
end
