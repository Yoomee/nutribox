# Don't delete comments! They are used in gems for adding abilities
class Ability
  
  include CanCan::Ability
  
  def initialize(user)
    
    # open ability
    can :create, Enquiry
    can [:read, :feed], Page
    can :create, Order
    can [:read, :latest], Box
    
    if user.try(:admin?)
      can :manage, :all      
      # admin ability
    elsif user
      # user ability
      can :index, Order
      can [:update, :show, :download, :thanks], Order, :user_id => user.id
      can :manage, User, :id => user.id      
    end
    
  end
  
end
