require "json"

module ModpackLocalizer
  module QuestGiver
    # Quest GiverのJSONファイルから翻訳対象テキストを抽出するクラス
    class Reader
      TRANSLATABLE_PATHS = [
        %w[start title text],
        %w[start description text],
        %w[complete title text],
        %w[complete description text]
      ].freeze

      # JSONファイルから翻訳対象テキストを抽出する
      #
      # @param [String] file_path ファイルのパス
      # @return [Array<Hash>] 翻訳対象テキストの配列
      def extract_all(file_path)
        json = JSON.parse(File.read(file_path))

        TRANSLATABLE_PATHS.filter_map do |keys|
          value = json.dig(*keys)
          next unless value

          { type: :quest_giver, path: keys.join("."), text: value }
        end
      end
    end
  end
end
