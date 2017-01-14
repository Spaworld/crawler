require 'rails_helper'

RSpec.describe Notifier do

  it 'should output process data' do
    node = build(:node)
    expect{ Notifier.output_process_info(node, 0) }
      .to output( "pid: 0 | sku: #{node.sku} | id :#{node.id}\n")
      .to_stdout
  end

  it 'should raise Invalid Node error' do
    expect {Notifier.raise_invalid_node}
      .to output { 'Invalid node' }
      .to_stdout
  end

  it 'should raise Data Present' do
    expect {Notifier.raise_data_exists}
      .to output { 'Data present' }
      .to_stdout
  end

end

