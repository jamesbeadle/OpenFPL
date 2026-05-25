export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      admin_allowlist: {
        Row: {
          added_at: string
          added_by: string | null
          email: string
        }
        Insert: {
          added_at?: string
          added_by?: string | null
          email: string
        }
        Update: {
          added_at?: string
          added_by?: string | null
          email?: string
        }
        Relationships: []
      }
      audit_log: {
        Row: {
          action: string
          actor_id: string | null
          created_at: string
          details: Json
          id: string
        }
        Insert: {
          action: string
          actor_id?: string | null
          created_at?: string
          details?: Json
          id?: string
        }
        Update: {
          action?: string
          actor_id?: string | null
          created_at?: string
          details?: Json
          id?: string
        }
        Relationships: []
      }
      bonus_plays: {
        Row: {
          bonus: Database["public"]["Enums"]["bonus_type"]
          gameweek_id: string
          id: string
          manager_id: string
          played_at: string
          season_id: string
          target_club_id: string | null
          target_nationality: string | null
          target_player_id: string | null
        }
        Insert: {
          bonus: Database["public"]["Enums"]["bonus_type"]
          gameweek_id: string
          id?: string
          manager_id: string
          played_at?: string
          season_id: string
          target_club_id?: string | null
          target_nationality?: string | null
          target_player_id?: string | null
        }
        Update: {
          bonus?: Database["public"]["Enums"]["bonus_type"]
          gameweek_id?: string
          id?: string
          manager_id?: string
          played_at?: string
          season_id?: string
          target_club_id?: string | null
          target_nationality?: string | null
          target_player_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "bonus_plays_gameweek_id_fkey"
            columns: ["gameweek_id"]
            isOneToOne: false
            referencedRelation: "gameweeks"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "bonus_plays_manager_id_fkey"
            columns: ["manager_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "bonus_plays_season_id_fkey"
            columns: ["season_id"]
            isOneToOne: false
            referencedRelation: "seasons"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "bonus_plays_target_club_id_fkey"
            columns: ["target_club_id"]
            isOneToOne: false
            referencedRelation: "clubs"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "bonus_plays_target_player_id_fkey"
            columns: ["target_player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
        ]
      }
      clubs: {
        Row: {
          id: string
          name: string
          primary_color: string | null
          short_name: string | null
          updated_at: string
        }
        Insert: {
          id: string
          name: string
          primary_color?: string | null
          short_name?: string | null
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          primary_color?: string | null
          short_name?: string | null
          updated_at?: string
        }
        Relationships: []
      }
      fantasy_team_players: {
        Row: {
          fantasy_team_id: string
          player_id: string
        }
        Insert: {
          fantasy_team_id: string
          player_id: string
        }
        Update: {
          fantasy_team_id?: string
          player_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fantasy_team_players_fantasy_team_id_fkey"
            columns: ["fantasy_team_id"]
            isOneToOne: false
            referencedRelation: "fantasy_teams"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fantasy_team_players_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
        ]
      }
      fantasy_teams: {
        Row: {
          bank_quarter_millions: number
          captain_player_id: string | null
          gameweek_id: string
          id: string
          manager_id: string
          transfers_made: number
          updated_at: string
        }
        Insert: {
          bank_quarter_millions: number
          captain_player_id?: string | null
          gameweek_id: string
          id?: string
          manager_id: string
          transfers_made?: number
          updated_at?: string
        }
        Update: {
          bank_quarter_millions?: number
          captain_player_id?: string | null
          gameweek_id?: string
          id?: string
          manager_id?: string
          transfers_made?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fantasy_teams_captain_player_id_fkey"
            columns: ["captain_player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fantasy_teams_gameweek_id_fkey"
            columns: ["gameweek_id"]
            isOneToOne: false
            referencedRelation: "gameweeks"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fantasy_teams_manager_id_fkey"
            columns: ["manager_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      fixture_events: {
        Row: {
          disallowed: boolean
          event_type: Database["public"]["Enums"]["fixture_event_type"]
          fixture_id: string
          id: string
          minute: number | null
          player_id: string | null
          updated_at: string
          value: number | null
        }
        Insert: {
          disallowed?: boolean
          event_type: Database["public"]["Enums"]["fixture_event_type"]
          fixture_id: string
          id: string
          minute?: number | null
          player_id?: string | null
          updated_at?: string
          value?: number | null
        }
        Update: {
          disallowed?: boolean
          event_type?: Database["public"]["Enums"]["fixture_event_type"]
          fixture_id?: string
          id?: string
          minute?: number | null
          player_id?: string | null
          updated_at?: string
          value?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "fixture_events_fixture_id_fkey"
            columns: ["fixture_id"]
            isOneToOne: false
            referencedRelation: "fixtures"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixture_events_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
        ]
      }
      fixtures: {
        Row: {
          away_club_id: string
          away_score: number | null
          finalised_at: string | null
          gameweek_id: string
          home_club_id: string
          home_score: number | null
          id: string
          kickoff: string
          status: Database["public"]["Enums"]["fixture_status"]
          updated_at: string
        }
        Insert: {
          away_club_id: string
          away_score?: number | null
          finalised_at?: string | null
          gameweek_id: string
          home_club_id: string
          home_score?: number | null
          id: string
          kickoff: string
          status?: Database["public"]["Enums"]["fixture_status"]
          updated_at?: string
        }
        Update: {
          away_club_id?: string
          away_score?: number | null
          finalised_at?: string | null
          gameweek_id?: string
          home_club_id?: string
          home_score?: number | null
          id?: string
          kickoff?: string
          status?: Database["public"]["Enums"]["fixture_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixtures_away_club_id_fkey"
            columns: ["away_club_id"]
            isOneToOne: false
            referencedRelation: "clubs"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixtures_gameweek_id_fkey"
            columns: ["gameweek_id"]
            isOneToOne: false
            referencedRelation: "gameweeks"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixtures_home_club_id_fkey"
            columns: ["home_club_id"]
            isOneToOne: false
            referencedRelation: "clubs"
            referencedColumns: ["id"]
          },
        ]
      }
      gameweek_scores: {
        Row: {
          calculated_at: string
          gameweek_id: string
          id: string
          is_provisional: boolean
          manager_id: string
          team_snapshot_id: string
          total_points: number
        }
        Insert: {
          calculated_at?: string
          gameweek_id: string
          id?: string
          is_provisional?: boolean
          manager_id: string
          team_snapshot_id: string
          total_points?: number
        }
        Update: {
          calculated_at?: string
          gameweek_id?: string
          id?: string
          is_provisional?: boolean
          manager_id?: string
          team_snapshot_id?: string
          total_points?: number
        }
        Relationships: [
          {
            foreignKeyName: "gameweek_scores_gameweek_id_fkey"
            columns: ["gameweek_id"]
            isOneToOne: false
            referencedRelation: "gameweeks"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "gameweek_scores_manager_id_fkey"
            columns: ["manager_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "gameweek_scores_team_snapshot_id_fkey"
            columns: ["team_snapshot_id"]
            isOneToOne: false
            referencedRelation: "team_snapshots"
            referencedColumns: ["id"]
          },
        ]
      }
      gameweeks: {
        Row: {
          created_at: string
          deadline: string
          footballgod_id: string | null
          id: string
          kickoff_window_end: string | null
          kickoff_window_start: string | null
          number: number
          season_id: string
          settled_at: string | null
          status: Database["public"]["Enums"]["gameweek_status"]
        }
        Insert: {
          created_at?: string
          deadline: string
          footballgod_id?: string | null
          id?: string
          kickoff_window_end?: string | null
          kickoff_window_start?: string | null
          number: number
          season_id: string
          settled_at?: string | null
          status?: Database["public"]["Enums"]["gameweek_status"]
        }
        Update: {
          created_at?: string
          deadline?: string
          footballgod_id?: string | null
          id?: string
          kickoff_window_end?: string | null
          kickoff_window_start?: string | null
          number?: number
          season_id?: string
          settled_at?: string | null
          status?: Database["public"]["Enums"]["gameweek_status"]
        }
        Relationships: [
          {
            foreignKeyName: "gameweeks_season_id_fkey"
            columns: ["season_id"]
            isOneToOne: false
            referencedRelation: "seasons"
            referencedColumns: ["id"]
          },
        ]
      }
      league_memberships: {
        Row: {
          joined_at: string
          league_id: string
          manager_id: string
        }
        Insert: {
          joined_at?: string
          league_id: string
          manager_id: string
        }
        Update: {
          joined_at?: string
          league_id?: string
          manager_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "league_memberships_league_id_fkey"
            columns: ["league_id"]
            isOneToOne: false
            referencedRelation: "private_leagues"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "league_memberships_manager_id_fkey"
            columns: ["manager_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      players: {
        Row: {
          club_id: string | null
          date_of_birth: string | null
          display_name: string
          first_name: string | null
          form: number
          id: string
          last_name: string | null
          nationality: string | null
          position: Database["public"]["Enums"]["player_position"]
          price_quarter_millions: number
          total_points: number
          updated_at: string
        }
        Insert: {
          club_id?: string | null
          date_of_birth?: string | null
          display_name: string
          first_name?: string | null
          form?: number
          id: string
          last_name?: string | null
          nationality?: string | null
          position: Database["public"]["Enums"]["player_position"]
          price_quarter_millions: number
          total_points?: number
          updated_at?: string
        }
        Update: {
          club_id?: string | null
          date_of_birth?: string | null
          display_name?: string
          first_name?: string | null
          form?: number
          id?: string
          last_name?: string | null
          nationality?: string | null
          position?: Database["public"]["Enums"]["player_position"]
          price_quarter_millions?: number
          total_points?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "players_club_id_fkey"
            columns: ["club_id"]
            isOneToOne: false
            referencedRelation: "clubs"
            referencedColumns: ["id"]
          },
        ]
      }
      private_leagues: {
        Row: {
          admin_id: string
          created_at: string
          id: string
          invite_code: string
          name: string
        }
        Insert: {
          admin_id: string
          created_at?: string
          id?: string
          invite_code: string
          name: string
        }
        Update: {
          admin_id?: string
          created_at?: string
          id?: string
          invite_code?: string
          name?: string
        }
        Relationships: [
          {
            foreignKeyName: "private_leagues_admin_id_fkey"
            columns: ["admin_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          created_at: string
          display_name: string | null
          id: string
          team_name: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          display_name?: string | null
          id: string
          team_name: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          display_name?: string | null
          id?: string
          team_name?: string
          updated_at?: string
        }
        Relationships: []
      }
      reserved_team_names: {
        Row: {
          added_at: string
          name_lower: string
          reason: string | null
        }
        Insert: {
          added_at?: string
          name_lower: string
          reason?: string | null
        }
        Update: {
          added_at?: string
          name_lower?: string
          reason?: string | null
        }
        Relationships: []
      }
      seasons: {
        Row: {
          created_at: string
          end_date: string
          footballgod_id: string | null
          id: string
          is_current: boolean
          name: string
          start_date: string
        }
        Insert: {
          created_at?: string
          end_date: string
          footballgod_id?: string | null
          id: string
          is_current?: boolean
          name: string
          start_date: string
        }
        Update: {
          created_at?: string
          end_date?: string
          footballgod_id?: string | null
          id?: string
          is_current?: boolean
          name?: string
          start_date?: string
        }
        Relationships: []
      }
      team_snapshot_players: {
        Row: {
          player_id: string
          price_quarter_millions: number
          team_snapshot_id: string
        }
        Insert: {
          player_id: string
          price_quarter_millions: number
          team_snapshot_id: string
        }
        Update: {
          player_id?: string
          price_quarter_millions?: number
          team_snapshot_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "team_snapshot_players_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "team_snapshot_players_team_snapshot_id_fkey"
            columns: ["team_snapshot_id"]
            isOneToOne: false
            referencedRelation: "team_snapshots"
            referencedColumns: ["id"]
          },
        ]
      }
      team_snapshots: {
        Row: {
          captain_player_id: string
          gameweek_id: string
          id: string
          locked_at: string
          manager_id: string
        }
        Insert: {
          captain_player_id: string
          gameweek_id: string
          id?: string
          locked_at?: string
          manager_id: string
        }
        Update: {
          captain_player_id?: string
          gameweek_id?: string
          id?: string
          locked_at?: string
          manager_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "team_snapshots_captain_player_id_fkey"
            columns: ["captain_player_id"]
            isOneToOne: false
            referencedRelation: "players"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "team_snapshots_gameweek_id_fkey"
            columns: ["gameweek_id"]
            isOneToOne: false
            referencedRelation: "gameweeks"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "team_snapshots_manager_id_fkey"
            columns: ["manager_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      webhook_deliveries: {
        Row: {
          error: string | null
          event_type: string
          id: string
          payload: Json
          processed_at: string | null
          received_at: string
          signature: string | null
          source: string
          status: string
        }
        Insert: {
          error?: string | null
          event_type: string
          id?: string
          payload: Json
          processed_at?: string | null
          received_at?: string
          signature?: string | null
          source: string
          status: string
        }
        Update: {
          error?: string | null
          event_type?: string
          id?: string
          payload?: Json
          processed_at?: string | null
          received_at?: string
          signature?: string | null
          source?: string
          status?: string
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      is_admin: { Args: never; Returns: boolean }
    }
    Enums: {
      bonus_type:
        | "GoalGetter"
        | "PassMaster"
        | "NoEntry"
        | "TeamBoost"
        | "SafeHands"
        | "CaptainFantastic"
        | "Prospects"
        | "OneNation"
        | "BraceBonus"
        | "HatTrickHero"
      fixture_event_type:
        | "Appearance"
        | "Goal"
        | "Assist"
        | "CleanSheet"
        | "Saves"
        | "PenaltySaved"
        | "GoalsConceded"
        | "YellowCard"
        | "RedCard"
        | "PenaltyMissed"
        | "OwnGoal"
        | "HighestScorerInFixture"
      fixture_status: "Scheduled" | "Live" | "Finalised"
      gameweek_status: "Upcoming" | "Active" | "Settled"
      player_position: "GK" | "DEF" | "MID" | "FWD"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      bonus_type: [
        "GoalGetter",
        "PassMaster",
        "NoEntry",
        "TeamBoost",
        "SafeHands",
        "CaptainFantastic",
        "Prospects",
        "OneNation",
        "BraceBonus",
        "HatTrickHero",
      ],
      fixture_event_type: [
        "Appearance",
        "Goal",
        "Assist",
        "CleanSheet",
        "Saves",
        "PenaltySaved",
        "GoalsConceded",
        "YellowCard",
        "RedCard",
        "PenaltyMissed",
        "OwnGoal",
        "HighestScorerInFixture",
      ],
      fixture_status: ["Scheduled", "Live", "Finalised"],
      gameweek_status: ["Upcoming", "Active", "Settled"],
      player_position: ["GK", "DEF", "MID", "FWD"],
    },
  },
} as const
