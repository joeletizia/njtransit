require 'nokogiri'
require 'pry'
require 'active_record'
require 'active_support/all'
require_relative './train_data'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/njtransit_analysis.sqlite3'
)

def train_data_already_recorded_today?(train_id)
  TrainData.where(train_id: train_id, created_at: Time.now.beginning_of_day..Time.now.end_of_day).any?
end

def persist_node(node)
  # Track, Line, Train id
  content =  "#{node.content}|#{node.next.next.content}|#{node.next.next.next.next.content}"
  track, line, train_id = content.split("|")
  if track.present? && train_id.present?
    TrainData.create(line: line, train_id: train_id, track: track) unless train_data_already_recorded_today?(train_id)
  end
end

html = `curl http://dv.njtransit.com/mobile/tid-mobile.aspx?sid=NY`

doc = Nokogiri::HTML(html)
nodes = doc.search('td[align="center"][valign="middle"]')

nodes.each do |node|
  persist_node(node)
end


