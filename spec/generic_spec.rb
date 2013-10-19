require 'spec_helper'

module VhdlTestScript
  describe Generic do
    subject { Generic.new('test', :in, Types::StdLogic.new) }

    describe '#mapping' do
      subject { generic.mapping(value) }

      describe 'std_logic' do
        let(:generic) { Generic.new('test', Types::StdLogic.new) }

        context 'value = 0' do
          let(:value) { 0 }
          it { should == "test => '0'" }
        end

        context 'value = 1' do
          let(:value) { 1 }
          it { should == "test => '1'" }
        end

      end

      describe 'std_logic_vector(8)' do
        let(:generic) { Generic.new('test', Types::StdLogicVector.new(8)) }

        context 'value = 0' do
          let(:value) { 0 }
          it { should == 'test => "00000000"' }
        end
      end

      describe 'default' do
        subject { generic.mapping() }

        describe 'std_logic' do
          context 'defalut = 1' do
            let(:generic) { Generic.new('test', Types::StdLogic.new, 1) }
            it { should == "test => '1'" }
          end

          context "defalut = '1'" do
            let(:generic) { Generic.new('test', Types::StdLogic.new, Value.new("'1'")) }
            it { should == "test => '1'" }
          end
        end
      end
    end
  end
end
