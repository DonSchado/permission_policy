require 'action_controller'

User = Struct.new(:role)

class PermissionTestController < ActionController::Metal
  include AbstractController::Helpers
  include AbstractController::Callbacks
  include PermissionPolicy::ControllerAdditions::InstanceMethods
  extend PermissionPolicy::ControllerAdditions::ClassMethods

  authorize_with :user
  verify_authorization!
  authorization_strategies :FeatureStrategy, :UnknownStrategy

  def user
    User.new('foo')
  end

  def index
    authorize! :index, feature: :fancy_feature
    'see me because allowed'
  end

  def delete
    authorize! :delete, feature: :fancy_feature
    'you wont see me'
  end
end


class FeatureStrategy < PermissionPolicy::Strategies::BaseStrategy
  def match?
    options[:feature]
  end

  def allowed?
    permissions.permitted? options[:feature].to_s, action.to_s, user.role
  end

  def permissions
    PermissionPolicy::PermissionReader.new(File.expand_path('../fixtures/permissions.yml', __FILE__))
  end
end

module PermissionPolicy
  RSpec.describe 'Integration' do
    subject { PermissionTestController.new }

    it { expect(subject.process_action :index).to eq("see me because allowed") }
    it { expect { subject.process_action :delete }.to raise_error PermissionPolicy::NotAllowed }
  end
end
