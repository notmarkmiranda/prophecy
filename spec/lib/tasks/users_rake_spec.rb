require 'rails_helper'
require 'rake'

RSpec.describe "users:find_inactive" do
  before(:all) do
    Rails.application.load_tasks
  end

  let(:run_task) { Rake::Task['users:find_inactive'].execute }
  let(:run_task_with_delete) { Rake::Task['users:find_inactive'].execute(delete: 'true') }
  let(:logger) { instance_double(Logger) }

  before do
    # Reset the task before each test
    Rake::Task['users:find_inactive'].reenable

    # Stub the logger to prevent actual file writing
    allow(Logger).to receive(:new).and_return(logger)
    allow(logger).to receive(:info)
    allow(logger).to receive(:warn)
    allow(logger).to receive(:error)
  end

  describe 'finding inactive users' do
    context 'when there are no users' do
      it 'reports no inactive users' do
        expect { run_task }.to output(/No inactive users found/).to_stdout
        expect(logger).to have_received(:info).with('No inactive users found.')
      end
    end

    context 'when there are users with associations' do
      let!(:active_user) { create(:user) }
      let!(:pool) { create(:pool, user: active_user) }

      it 'does not identify them as inactive' do
        expect { run_task }.to output(/No inactive users found/).to_stdout
      end
    end

    context 'when there are users without associations' do
      let(:email) { "inactive#{SecureRandom.hex(20)}@example.com" }
      let!(:inactive_user) { create(:user, email: email) }

      it 'identifies them as inactive' do
        output = capture_stdout { run_task }
        expect(output).to include('Found 1 inactive users')
        expect(output).to include(email)
        expect(output).to include('No Pools')
        expect(output).to include('No Groups')
        expect(output).to include('No Memberships')
      end
    end

    context 'when there is a mix of active and inactive users' do
      let(:active_email) { "active#{SecureRandom.hex(20)}@example.com" }
      let(:inactive_email) { "inactive#{SecureRandom.hex(20)}@example.com" }
      let!(:active_user) { create(:user, email: active_email) }
      let!(:inactive_user) { create(:user, email: inactive_email) }
      let!(:pool) { create(:pool, user: active_user) }

      it 'only identifies users without associations' do
        output = capture_stdout { run_task }
        expect(output).to include('Found 1 inactive users')
        expect(output).to include(inactive_email)
        expect(output).not_to include(active_email)
      end
    end
  end

  describe 'deleting inactive users' do
    context 'when running in delete mode' do
      let(:active_email) { "active#{SecureRandom.hex(20)}@example.com" }
      let(:inactive_email) { "inactive#{SecureRandom.hex(20)}@example.com" }
      let!(:inactive_user) { create(:user, email: inactive_email) }
      let!(:active_user) { create(:user, email: active_email) }
      let!(:pool) { create(:pool, user: active_user) }

      it 'deletes only inactive users' do
        expect {
          capture_stdout { run_task_with_delete }
        }.to change(User, :count).by(-1)

        expect(User.find_by(email: inactive_email)).to be_nil
        expect(User.find_by(email: active_email)).to be_present
      end

      it 'logs deletion success' do
        output = capture_stdout { run_task_with_delete }
        expect(output).to include("✓ Deleted user #{inactive_email}")
        expect(logger).to have_received(:info).with(/✓ Deleted user #{inactive_email}/)
      end
    end

    context 'when deletion fails' do
      let(:inactive_email) { "inactive#{SecureRandom.hex(20)}@example.com" }
      let!(:inactive_user) { create(:user, email: inactive_email) }

      before do
        allow(inactive_user).to receive(:destroy).and_raise(StandardError.new("Test error"))
        allow(User).to receive(:all).and_return([ inactive_user ])
      end

      it 'logs the error and continues' do
        output = capture_stdout { run_task_with_delete }
        expect(output).to include("✗ Failed to delete user #{inactive_email}")
        expect(logger).to have_received(:error).with(/✗ Failed to delete user #{inactive_email}.*Test error/)
      end
    end
  end

  private

  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end
end
