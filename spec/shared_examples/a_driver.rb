shared_examples_for('a driver') do

  context 'initialization' do

    describe 'driver' do

      let(:subject) { described_class.new(BillyDriver.new) }

      it { is_expected.to respond_to(:driver) }

      it 'should have a valid driver' do
        connector = described_class.new(
          BillyDriver.new)
        expect(connector.driver.class)
          .to eq(BillyDriver)
      end

      it 'should not railse Argument Error when /
      valid driver is injected' do
        valid_driver = BillyDriver.new
        expect { described_class.new(valid_driver) }
          .to_not raise_error
      end

      it 'should raise Invalid driver when nil /
      driver is injected' do
        expect { described_class.new(nil) }
          .to raise_error(ArgumentError, 'Invalid driver')
      end

      it 'should raise Invalid driver when falsey /
      driver is injected' do
        expect { described_class.new(Class.new) }
          .to raise_error(ArgumentError, 'Invalid driver')
      end

    end

  end

end
