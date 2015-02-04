require 'action_controller'

class MetalTestController < ActionController::Metal
  include AbstractController::Helpers
  include AbstractController::Callbacks
  include PermissionPolicy::ControllerAdditions::InstanceMethods
  extend PermissionPolicy::ControllerAdditions::ClassMethods

  authorize_with :foo, :bar
  verify_authorization!
  authorization_strategies :TestStrategy, :UnknownStrategy

  def foo
    'foo'
  end

  def bar
    'bar'
  end

  def baz
    'baz'
  end
end

class TestController < MetalTestController
  def not_authorized_action
    'you will never see me'
  end

  def not_allowed_action
    authorize! :something
    'you also wont see me, but get a different error'
  end

  def allowed_action
    authorize! :view, subject: 'some_subject'
    'ok go ahead'
  end
end

class TestStrategy < PermissionPolicy::Strategies::BaseStrategy
  def match?
    options[:subject] == 'some_subject'
  end

  def allowed?
    { view: true, manage: false }[action]
  end
end

class SkipTestController < MetalTestController
  authorize_with :baz
  skip_verify_authorization

  def skipped_authorization
    'ohai'
  end
end


module PermissionPolicy
  RSpec.describe 'ControllerAdditions' do

    context 'instance_methods' do
      subject { MetalTestController.new }

      describe 'authorization' do
        it 'is available through #permission_policy' do
          expect(subject.permission_policy).to be_kind_of(PermissionPolicy::Authorization)
        end

        it 'is initialized with precondition foo' do
          expect(subject.permission_policy.foo).to eq('foo')
        end

        it 'is initialized with precondition bar' do
          expect(subject.permission_policy.bar).to eq('bar')
        end
      end

      describe 'helpers' do
        it { is_expected.to respond_to :authorize! }
        it { is_expected.to respond_to :allowed? }
      end
    end

    context 'class_methods' do
      subject { TestController.new }

      describe '#verify_authorization!' do
        context 'no call to #authorize!' do
          it 'is not verified' do
            expect { subject.process_action :not_authorized_action }.to raise_error PermissionPolicy::NotVerified
          end
        end

        context 'with #authorize! but not allowed' do
          it 'is still not allowed' do
            expect { subject.process_action :not_allowed_action }.to raise_error PermissionPolicy::NotAllowed
          end
        end

        context '#authorized! and allowed' do
          it 'is allowed' do
            expect(subject.process_action :allowed_action).to eq('ok go ahead')
          end
        end
      end
    end

    describe '#skip_verify_authorization' do
      subject { SkipTestController.new }

      context 'with :only option' do
        it 'skips this action' do
          expect(subject.process_action :skipped_authorization).to eq('ohai')
        end
      end
    end

  end
end
