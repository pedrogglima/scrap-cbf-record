# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    class Base
      def initialize(
        config,
        championship,
        match,
        ranking,
        round,
        team

      )
        # classes set by users
        # e.g @class_championship => # may be Cup class
        #
        #
        @class_championship = championship
        @class_match = match
        @class_ranking = ranking
        @class_round = round
        @class_team = team

        # config for one of the record classes
        #
        @config = config

        # returns whether record has or not specific association
        #
        @championship_assoc = @config.championship_assoc?
        @round_assoc = @config.round_assoc?
        @team_assoc = @config.team_assoc?

        # configs set by users
        #
        @associations = @config.associations
        @exclude_attrs_on_create = @config.exclude_attrs_on_create
        @exclude_attrs_on_update = @config.exclude_attrs_on_update
        @rename_attrs = @config.rename_attrs

        # configs required by the lib
        #
        @must_exclude_attrs = @config.must_exclude_attrs
        @must_keep_attrs = @config.must_keep_attrs
        @must_not_rename_attrs = @config.must_not_rename_attrs
      end

      def normalize_before_create(hash, assocs = {})
        hash = include_associations(
          hash,
          @associations,
          assocs
        )

        hash = exclude_attrs(
          hash,
          @exclude_attrs_on_create,
          @must_exclude_attrs,
          @must_keep_attrs,
          @associations
        )

        rename_attrs(hash, @rename_attrs, @must_not_rename_attrs)
      end

      def normalize_before_update(hash, assocs = {})
        hash = include_associations(
          hash,
          @associations,
          assocs
        )

        hash = exclude_attrs(
          hash,
          @exclude_attrs_on_update,
          @must_exclude_attrs,
          @must_keep_attrs,
          @associations
        )

        rename_attrs(hash, @rename_attrs, @must_not_rename_attrs)
      end

      protected

      def find_championship(year)
        if @championship_assoc || @config.self_assoc?(:championship)
          @class_championship.find_by(year: year)
        else
          year
        end
      end

      def find_match(id_match, championship)
        if @championship_assoc
          find_match_with_association_fk(id_match, championship)
        else
          find_match_without_association_fk(id_match, championship)
        end
      end

      def find_match_with_association_fk(id_match, championship)
        @class_match.find_by(
          id_match: id_match,
          championship_id: championship.id
        )
      end

      def find_match_without_association_fk(id_match, championship)
        @class_match.find_by(
          id_match: id_match,
          year: championship
        )
      end

      def find_ranking(posicao, championship)
        if @championship_assoc
          find_ranking_with_association_fk(posicao, championship)
        else
          find_ranking_without_association_fk(posicao, championship)
        end
      end

      def find_ranking_with_association_fk(posicao, championship)
        @class_ranking.find_by(
          posicao: posicao,
          championship_id: championship.id
        )
      end

      def find_ranking_without_association_fk(posicao, championship)
        @class_ranking.find_by(
          posicao: posicao,
          year: championship
        )
      end

      def find_round(number, championship)
        if @round_assoc || @config.self_assoc?(:round)
          find_round_on_database(number, championship)
        else
          number
        end
      end

      def find_round_on_database(number, championship)
        if @championship_assoc
          find_round_with_association_fk(number, championship)
        else
          find_round_without_association_fk(number, championship)
        end
      end

      def find_round_with_association_fk(number, championship)
        @class_round.find_by(
          number: number,
          championship_id: championship.id
        )
      end

      def find_round_without_association_fk(number, championship)
        @class_round.find_by(
          number: number,
          year: championship
        )
      end

      def find_team(name)
        if @team_assoc || @config.self_assoc?(:team)
          @class_team.find_by(name: name)
        else
          name
        end
      end

      def include_associations(hash, associations, assocs)
        associations.each do |assocition|
          key = "#{assocition}_id"
          instance = assocs[assocition.to_sym]

          # cases where associations is nil
          hash[key.to_sym] = instance.present? ? instance.id : nil
        end

        hash
      end

      def exclude_attrs(
        hash,
        attrs,
        must_exclude,
        must_keep,
        associations
      )
        exclude = (
          attrs +
          associations +
          must_exclude
        ) - must_keep

        hash.except(*exclude)
      end

      def rename_attrs(hash, renames, must_keep)
        renames = renames.except(must_keep)

        renames.each do |key, val|
          hash[val.to_sym] = hash.delete(key) if hash.key?(key)
        end

        hash
      end

      def raise_unless_respond_to_each(records, records_type)
        return if records.respond_to?(:each)

        raise ::ArgumentError, "#{records_type} must respond to method :each"
      end
    end
  end
end
