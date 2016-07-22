require 'spec_helper'

module Convection::DSL
  describe IntrinsicFunctions do
    include described_class

    let(:apples_to_oranges) do
      { 'Fn::Equals' => %w(apples oranges) }
    end

    let(:apples_to_apples) do
      { 'Fn::Equals' => %w(apples apples) }
    end

    let(:value_if_true) do
      { 'Ref' => 'ValueOne' }
    end

    let(:value_if_false) do
      { 'Ref' => 'ValueTwo' }
    end

    it 'defines #base64' do
      actual = base64('message to encode')
      expect(actual).to eq('Fn::Base64' => 'message to encode')
    end

    it 'defines #fn_and' do
      actual = fn_and(apples_to_oranges, apples_to_apples)

      expect(actual).to eq('Fn::And' => [apples_to_oranges, apples_to_apples])
    end

    it 'defines #fn_equals' do
      actual = fn_equals('apples', 'oranges')
      expect(actual).to eq(apples_to_oranges)
    end

    it 'defines #fn_if' do
      actual = fn_if('UseDBSnapshot', value_if_true, value_if_false)
      expect(actual).to eq(
        'Fn::If' => ['UseDBSnapshot', value_if_true, value_if_false]
      )
    end

    it 'defines #fn_not' do
      actual = fn_not(apples_to_oranges)
      expect(actual).to eq('Fn::Not' => [apples_to_oranges])
    end

    it 'defines #fn_or' do
      actual = fn_or(apples_to_oranges, apples_to_apples)
      expect(actual).to eq('Fn::Or' => [apples_to_oranges, apples_to_apples])
    end

    it 'defines #find_in_map' do
      actual = find_in_map('RegionMap', 'us-east-1', '32')
      expect(actual).to eq(
        'Fn::FindInMap' => ['RegionMap', 'us-east-1', '32']
      )
    end

    it 'defines #get_att' do
      actual = get_att('MyLB', 'DNSName')
      expect(actual).to eq('Fn::GetAtt' => %w(MyLB DNSName))
    end

    it 'defines #get_azs' do
      actual = get_azs('us-east-1')
      expect(actual).to eq('Fn::GetAZs' => 'us-east-1')
    end

    it 'defines #join' do
      actual = join(' ', 'Hello', 'World')
      expect(actual).to eq('Fn::Join' => [' ', %w(Hello World)])
    end

    it 'defines #select' do
      actual = select('2', 'duck', 'duck', 'goose')
      expect(actual).to eq('Fn::Select' => ['2', %w(duck duck goose)])
    end

    it 'defines #fn_ref' do
      actual = fn_ref('SomeLogicalName')
      expect(actual).to eq('Ref' => 'SomeLogicalName')
    end
  end
end
