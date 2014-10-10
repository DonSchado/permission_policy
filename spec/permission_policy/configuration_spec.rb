module PermissionPolicy
  RSpec.describe Configuration do
    before { PermissionPolicy.configuration = nil }
    subject { PermissionPolicy.config }

    it { expect(subject).to be_kind_of(PermissionPolicy::Configuration) }

    it 'has a default precondition' do
      expect(subject.preconditions).to eq([:current_user])
    end

    it 'has a default strategy' do
      expect(subject.strategies).to eq([:UnknownStrategy])
    end
  end
end
