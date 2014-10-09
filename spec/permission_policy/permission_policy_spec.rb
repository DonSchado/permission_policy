module PermissionPolicy
  RSpec.describe 'Configuration' do
    subject { PermissionPolicy.config }

    it { expect(subject).to be_kind_of(PermissionPolicy::Configuration) }

    it 'has a default precondition' do
      expect(subject.precondition_attributes).to eq([:current_user])
    end
  end
end
