module PoolsHelper
  def can_manage_pool?(pool)
    pool.user == current_user || pool.admins.include?(current_user)
  end

  def pool_unlocked?(pool)
    pool.locked_at.nil? || pool.locked_at > Time.current
  end

  def accepting_entries?(pool, questions)
    questions.any? && pool_unlocked?(pool) && pool.completed_at.nil?
  end
end
