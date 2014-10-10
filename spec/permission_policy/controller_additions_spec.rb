require 'action_controller'

class MetalTestController < ActionController::Metal
  include AbstractController::Helpers
  include PermissionPolicy::ControllerAdditions::InstanceMethods
  extend PermissionPolicy::ControllerAdditions::ClassMethods

  def foo
  end

  def bar
  end
end


module PermissionPolicy
  RSpec.describe 'ControllerAdditions' do
    subject { MetalTestController.new }

    context 'authorization' do
      before do
        MetalTestController.authorize_with :foo, :bar
        is_expected.to receive(:foo) { 'foo' }
        is_expected.to receive(:bar) { 'bar' }
      end

      it 'is available throuth #permission_policy' do
        expect(subject.permission_policy).to be_kind_of(PermissionPolicy::Authorization)
      end

      it 'is initialized with preconditions' do
        expect(subject.permission_policy.foo).to eq('foo')
        expect(subject.permission_policy.bar).to eq('bar')
      end
    end

    context 'helpers' do
      it { is_expected.to respond_to :authorize! }
      it { is_expected.to respond_to :allowed? }
    end
  end
end
