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
    #Store
      can [:read, :show_search_result], Store
      can [:create, :update], Store
      can :destroy, Store do |store|
        store.try(:user) == user
      end
      can :search, :stores                    # two non-RESTful actions that allow user to search for a store
    #Menu  
      can :show, Menu
      can [:add, :confirm, :save], Menu       # add new items to menu
      can [:edit_order, :update_order], Menu  # change order which menu items and categories are presented
    #Dish
      can :show, Dish
      can :destroy, Dish do |dish|
        dish.try(:user) == user
      end
    #Visit  
      can :read, Visit, :user_id => user.id   # 2do: add ability to see friend's visits but not in index only in store-specific lists (so maybe no need here)
      can :show, Visit, :visibility_mask => 1   
      can [:create, :show_friend], Visit
      # update on visit updates the items ordered, while update_parameters changes the ratings, review text, pictures etc.
      can [:update, :destroy, :edit_parameters, :update_parameters], Visit do |visit|
        visit.try(:user) == user
      end
    #VisitReport
      can :index, VisitReport
    #DishReview  
      can :show, DishReview, :visibility_mask => 1   
      can [:destroy, :delete_picture], DishReview do |dish_review|
        dish_review.try(:user) == user
      end
    #StoreList
      can :read, StoreList, :user_id => user.id
      can :show, StoreList, :visibility_mask => 1   
      can :create, StoreList
      can [:update, :destroy, :add_item], StoreList do |sl|
        sl.try(:user) == user
      end
    #StoreListEntry
      can :destroy, StoreListEntry do |sle|
        sle.try(:store_list).user == user
      end  
    #VisitedStoreListReport
      can :index, VisitedStoreListReport
    #User  
      can :read, User, :id => user.id
        # u.try(:friend?, user)  #verify u and user are friends
        # be careful this must work in the context of accessible_by etc.
      can [:show_my_following, :update_friend_list], User
      can :update, User do |u|
        u == user
      end
    #Authentication  
      can [:read, :destroy], Authentication, :user_id => user.id
    end
  end
end
