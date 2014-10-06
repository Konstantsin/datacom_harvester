require 'spec_helper'

describe RequestQueue do
  let(:queue) { RequestQueue.new }
  after { queue.reset }

  describe '#add' do
    it 'should add new item to queue' do
      queue.added_at = Time.now
      expect{queue.add('item')}.to change{queue.items_list.count}.by(1)
      expect(queue.add('item')).to be_true
    end

    describe 'when exceeded' do
      it 'limit per day' do
        queue.items_per_today = RequestQueue::ITEMS_DAY_LIMIT
        expect{queue.add('item')}.to change{queue.items_list.count}.by(0)
      end

      it 'limit per minut should wait second minute' do
        queue.items_per_minut = 3
        [13, 25, 45, 57].each do |num|
          queue.added_at = Time.now - num.seconds
          expect(queue.send(:wait_seconds)).to eq num + 1
        end
      end

      it "current minute then items_per_minut should be 0" do
        [100, 91].each do |num|
          queue.items_per_minut = 2
          queue.added_at = Time.now - num.seconds
          expect{queue << 'altoros'}.to change{queue.items_per_minut}.from(2).to(4)
        end
      end
    end
  end

  describe '#reset' do
    it 'should reset limit counters to 0' do
      queue.items_per_today = 5
      expect{queue.reset}.to change{queue.items_per_today}.from(5).to(0)

      queue.items_per_minut = 3
      expect{queue.reset}.to change{queue.items_per_minut}.from(3).to(0)
    end
  end
end
