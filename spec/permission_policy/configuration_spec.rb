module PermissionPolicy
  RSpec.describe Configuration do
    before { PermissionPolicy.configuration = nil }

    it 'has a default precondition' do
      expect(subject.preconditions).to eq([:current_user])
    end

    it 'has a default strategy' do
      expect(subject.strategies).to eq([:UnknownStrategy])
    end
  end
end
