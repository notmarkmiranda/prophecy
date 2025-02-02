INACTIVE_USER_ASSOCIATIONS = {
  memberships: "Membership",
  pools: "Pool",
  groups: "Group"
}.freeze

namespace :users do
  desc "Find and optionally delete users with no associations (inactive users)"
  task :find_inactive, [ :delete ] => :environment do |t, args|
    delete_mode = args[:delete] == "true"
    log_file = Rails.root.join("log", "inactive_users_deletion.log")
    logger = Logger.new(log_file)

    # Find users with no associations
    inactive_users = User.all.select do |user|
      INACTIVE_USER_ASSOCIATIONS.all? do |association, model|
        if user.respond_to?(association)
          user.public_send(association).empty?
        else
          logger.warn "Warning: #{model} association not found on User model"
          true
        end
      end
    end

    if inactive_users.any?
      message = "\nFound #{inactive_users.count} inactive users:"
      puts message
      logger.info(message)

      inactive_users.each do |user|
        user_info = "- #{user.email} (ID: #{user.id})"
        puts user_info
        logger.info(user_info)

        # Print details about missing associations
        missing_associations = []
        INACTIVE_USER_ASSOCIATIONS.each do |association, model|
          detail = "  • No #{model.pluralize}"
          puts detail
          missing_associations << model.pluralize
        end
        logger.info("  Missing associations: #{missing_associations.join(", ")}")
        puts ""

        if delete_mode
          begin
            user.destroy
            deletion_message = "✓ Deleted user #{user.email} (ID: #{user.id})"
            puts deletion_message
            logger.info(deletion_message)
          rescue => e
            error_message = "✗ Failed to delete user #{user.email} (ID: #{user.id}): #{e.message}"
            puts error_message
            logger.error(error_message)
          end
        end
      end

      if delete_mode
        puts "\nDeletion complete. Check #{log_file} for detailed logs."
      else
        puts "\nRun with delete=true to remove these users:"
        puts "rake users:find_inactive[true]"
      end
    else
      message = "No inactive users found."
      puts message
      logger.info(message)
    end
  end
end
