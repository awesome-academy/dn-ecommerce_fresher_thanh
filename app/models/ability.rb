class Ability
  include CanCan::Ability

  def initialize user
    not_login_can
    return if user.blank?

    user_can user
    return unless user.admin?

    admin_can
  end

  private

  def not_login_can
    can :read, Product
  end

  def user_can user
    can [:create, :update, :destroy], Order, user_id: user.id
  end

  def admin_can
    can :manage, :all
  end
end
