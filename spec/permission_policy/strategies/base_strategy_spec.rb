module PermissionPolicy
  module Strategies
    RSpec.describe BaseStrategy do

      context 'valid' do
        let(:authorization) { double('authorization', preconditions: [:current_user], current_user: 'me') }
        let(:action) { :foo }
        let(:options) { { something: 'nice' } }

        subject { described_class.new(authorization, action, options) }

        it 'sets dynamic attributes' do
          expect(subject.current_user).to eq('me')
        end

        it 'sets action' do
          expect(subject.action).to eq(:foo)
        end

        it 'sets options' do
          expect(subject.options[:something]).to eq('nice')
        end
      end

    end
  end
end