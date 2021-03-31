# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    # Superclass for the classes lib/active_records/<record>.rb
    class Base
      def initialize(current_config, config)
        # classes set by users
        # e.g @class_championship => # may be Cup class
        #
        @class_championship = config.championship.constant
        @class_match = config.match.constant
        @class_ranking = config.ranking.constant
        @class_round = config.round.constant
        @class_team = config.team.constant

        # current config is associated with the current record class
        #
        @current_config = current_config
        # configs associated with the record classes
        #
        @config_match = config.match
        @config_ranking = config.ranking
        @config_round = config.round
        @config_team = config.team

        # current configs set by users
        #
        @associations = @current_config.associations
        @exclude_attrs_on_create = @current_config.exclude_attrs_on_create
        @exclude_attrs_on_update = @current_config.exclude_attrs_on_update
        @rename_attrs = @current_config.rename_attrs

        # current configs required by the system
        #
        @must_exclude_attrs = @current_config.must_exclude_attrs
      end

      # Normalize, on create, the new record with:
      # Setting Associations
      # Rename attributes
      # Exclusion of attributes
      #
      # @param [Hash] contaning the new record
      # @param [Hash] contaning the existent record's associations
      # @return [Hash] normalized
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
          @associations.keys
        )

        hash = rename_attrs(hash, @rename_attrs)

        hash
      end

      # Normalize, on update, the new record with:
      # Setting Associations
      # Rename attributes
      # Exclusion of attributes
      #
      # @param [Hash] contaning the new record
      # @param [Hash] contaning the existent record's associations
      # @return [Hash] normalized
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
          @associations.keys
        )

        hash = rename_attrs(hash, @rename_attrs)

        hash
      end

      # Save record instance or log the errors found
      #
      # @raise [ActiveRecordError]
      # @param record [ActiveRecord] instance to be saved
      # @return [ActiveRecord] the instance saved
      def save_or_log_error(record)
        if record.valid?
          record.save
        else
          log_record_errors(record)
          raise ActiveRecordValidationError
        end
        record
      end

      protected

      def find_championship!(year)
        instance = if @current_config.championship_assoc? ||
                      @current_config.record_is_a?(:championship)

                     @class_championship.find_by(year: year)
                   else
                     year
                   end

        raise ChampionshipInstanceNotFoundError, year unless instance

        instance
      end

      def find_match(id_match, championship, serie)
        if @current_config.championship_assoc?
          find_match_with_association_fk(id_match, championship)
        else
          find_match_without_association_fk(id_match, championship, serie)
        end
      end

      def find_match_with_association_fk(id_match, championship)
        @class_match.find_by(
          "#{@config_match.searchable_attr(:id_match)}": id_match,
          "#{@config_match.searchable_attr(:championship_id)}": championship.id
        )
      end

      def find_match_without_association_fk(id_match, championship, serie)
        @class_match.find_by(
          "#{@config_match.searchable_attr(:id_match)}": id_match,
          "#{@config_match.searchable_attr(:championship)}": championship,
          "#{@config_match.searchable_attr(:serie)}": serie
        )
      end

      def find_ranking(position, championship, serie)
        if @current_config.championship_assoc?
          find_ranking_with_association_fk(position, championship)
        else
          find_ranking_without_association_fk(position, championship, serie)
        end
      end

      def find_ranking_with_association_fk(position, championship)
        @class_ranking.find_by(
          "#{@config_ranking.searchable_attr(:position)}": position,
          "#{@config_ranking.searchable_attr(:championship_id)}": championship.id
        )
      end

      def find_ranking_without_association_fk(position, championship, serie)
        @class_ranking.find_by(
          "#{@config_ranking.searchable_attr(:position)}": position,
          "#{@config_ranking.searchable_attr(:championship)}": championship,
          "#{@config_ranking.searchable_attr(:serie)}": serie
        )
      end

      def find_round(number, championship, serie)
        if @current_config.round_assoc? || @current_config.record_is_a?(:round)
          find_round_on_database(number, championship, serie)
        else
          number
        end
      end

      def find_round_on_database(number, championship, serie)
        if @current_config.championship_assoc?
          find_round_with_association_fk(number, championship)
        else
          find_round_without_association_fk(number, championship, serie)
        end
      end

      def find_round_with_association_fk(number, championship)
        @class_round.find_by(
          "#{@config_round.searchable_attr(:number)}": number,
          "#{@config_round.searchable_attr(:championship_id)}": championship.id
        )
      end

      def find_round_without_association_fk(number, championship, serie)
        @class_round.find_by(
          "#{@config_round.searchable_attr(:number)}": number,
          "#{@config_round.searchable_attr(:championship)}": championship,
          "#{@config_round.searchable_attr(:serie)}": serie
        )
      end

      def find_team(name)
        if @current_config.team_assoc? || @current_config.record_is_a?(:team)
          @class_team.find_by("#{@config_team.searchable_attr(:name)}": name)
        else
          name
        end
      end

      def include_associations(hash, associations, assocs)
        associations.each do |name, attrs|
          instance = assocs[name.to_sym]

          foreign_key = attrs[:foreign_key]

          # for cases where instance is:
          # - association is empty (nil)
          # - association is present
          #
          # update hash with the foreign_key
          hash[foreign_key.to_sym] = (instance.id if instance.present?)
        end

        hash
      end

      def exclude_attrs(hash, attrs, must_exclude, associations)
        exclude = attrs + associations + must_exclude
        hash.except(*exclude)
      end

      def rename_attrs(hash, renames)
        # rename attrs
        renames.each do |key, val|
          hash[val.to_sym] = hash.delete(key) if hash.key?(key)
        end

        hash
      end

      def raise_unless_respond_to_each(records, records_type)
        return if records.respond_to?(:each)

        raise ::ArgumentError, "#{records_type} must respond to method :each"
      end

      def log_record_errors(record)
        TagLogger.with_context(record.class, 'Errors found while saving')
        record.errors.each do |attribute, message|
          TagLogger.with_context('error', "#{attribute}: #{message}")
        end
      end
    end
  end
end
