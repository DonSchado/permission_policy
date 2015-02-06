module PermissionPolicy
  RSpec.describe PermissionReader do
    let(:test_file) { File.expand_path('../fixtures/permissions.yml', __FILE__) }
    subject { described_class.new(test_file) }

    it { expect(subject.features).to eq(['fancy_feature', 'user_management']) }
    it { expect(subject.roles).to eq(['super_admin', 'foo', 'bar', 'baz']) }
    it { expect(subject.permitted?('fancy_feature', 'create', 'foo')).to eq(true)}
    it { expect(subject.permitted?('fancy_feature', 'index', 'bar')).to eq(false)}
    it { expect(subject.permitted?('fancy_feature', 'delete', 'foo')).to eq(false)}

    it 'no such Feature' do
      expect { subject.permitted?(:yay, 'nay', 'hey') }
        .to raise_error(PermissionPolicy::ReaderError, 'yay not defined')
    end

    it 'no such Action' do
      expect { subject.permitted?('fancy_feature', :nay, 'hey') }
        .to raise_error(PermissionPolicy::ReaderError, 'nay not defined')
    end

    it 'no such Role' do
      expect { subject.permitted?('fancy_feature', 'index', 'hey')
         }.to raise_error(PermissionPolicy::ReaderError, 'hey not defined')
    end
  end
end
