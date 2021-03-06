require 'nokogiri'
require 'pry'
require 'active_record'
require_relative '../../train_data'

module NJTransit
  module ScheduleSucker
    module_function

    def run
      html = `curl http://dv.njtransit.com/mobile/tid-mobile.aspx?sid=NY`

      doc = Nokogiri::HTML(html)
      nodes = doc.search('td[align="center"][valign="middle"]')

      nodes.each do |node|
        persist_node(node)
      end

    end

    def train_data_already_recorded_today?(train_id)
      TrainData.where(train_id: train_id, created_at: Time.now.beginning_of_day..Time.now.end_of_day).any?
    end
    private_class_method :train_data_already_recorded_today?


    def persist_node(node)
      # Track, Line, Train id
      content =  "#{node.content}|#{node.next.next.content}|#{node.next.next.next.next.content}"
      track, line, train_id = content.split("|")
      if track.present? && train_id.present?
        TrainData.create(line: line, train_id: train_id, track: track) unless train_data_already_recorded_today?(train_id)
      end
    end
    private_class_method :persist_node

  end
end
