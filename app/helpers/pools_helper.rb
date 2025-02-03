module PoolsHelper
  def can_manage_pool?(pool)
    pool.user == current_user || pool.admins.include?(current_user)
  end

  def pool_unlocked?(pool)
    pool.locked_at.nil? || pool.locked_at > Time.current
  end
end
