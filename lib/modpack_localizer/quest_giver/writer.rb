require "json"

module ModpackLocalizer
  module QuestGiver
    # Quest GiverのJSONファイルに翻訳済みテキストを書き戻すクラス
    class Writer
      # @param [String] file_path ファイルのパス
      # @return [ModpackLocalizer::QuestGiver::Writer]
      def initialize(file_path)
        @input_file_path = file_path
        @output_file_path = file_path.gsub("quest_giver/", "output/quest_giver/")
      end

      # 翻訳済みテキストでJSONを上書きする
      #
      # @param [Hash] translated_content 翻訳済みの内容
      # @return [void]
      def overwrites(translated_content)
        FileUtils.mkdir_p(File.dirname(@output_file_path))

        json = JSON.parse(File.read(first_overwrite? ? @input_file_path : @output_file_path))
        keys = translated_content[:path].split(".")
        dig_and_set(json, keys, translated_content[:text])

        File.open(@output_file_path, "w") do |file|
          file.puts JSON.pretty_generate(json)
        end
      end

      private

      # ネストされたハッシュの指定パスに値をセットする
      #
      # @param [Hash] hash 対象のハッシュ
      # @param [Array<String>] keys パスのキー配列
      # @param [String] value セットする値
      # @return [void]
      def dig_and_set(hash, keys, value)
        parent = hash.dig(*keys[0..-2])
        parent[keys.last] = value
      end

      # 最初の上書きかどうか
      #
      # @return [Boolean]
      def first_overwrite?
        !File.exist?(@output_file_path)
      end
    end
  end
end
