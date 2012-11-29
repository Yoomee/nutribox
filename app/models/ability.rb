# Don't delete comments! They are used in gems for adding abilities
class Ability
  
  include CanCan::Ability
  
  def initialize(user)
    
    # open ability
    can :read, Page
    can :create, Order
    can :new, Referral
    
    if user.try(:admin?)
      can :manage, :all      
      # admin ability
    elsif user
      # user ability
      can :index, Order
      can :index, Referral
      can [:update, :show], Order, :user_id => user.id
      can :manage, User, :id => user.id      
    end
    
  end
  
end
