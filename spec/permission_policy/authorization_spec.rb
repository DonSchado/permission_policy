module PermissionPolicy
  RSpec.describe 'Authorization' do
    subject { PermissionPolicy::Authorization.new(controller_context) }

    context 'valid' do
      let(:controller_context) { double('context', authorization_preconditions: [:my_user, :my_account], my_user: 'foo', my_account: 'bar') }

      it 'sets attribute readers for each precondition' do
        expect(subject.my_user).to eq('foo')
        expect(subject.my_account).to eq('bar')
      end

      it 'remembers precondition attributes' do
        expect(subject.preconditions).to eq([:my_user, :my_account])
      end
    end

    context 'invalid' do
      let(:controller_context) { double('context', authorization_preconditions: [:my_user, :my_account], my_user: nil, my_account: nil) }

      it 'raises missing precondition error' do
        expect { subject }.to raise_error('missing precondition: my_user')
      end
    end
  end
end
