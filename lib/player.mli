type player

val init_player : string -> player
(** [init_player name] is a player with [name] name, an empty list as their
    hand, 0 as their starting [bank], and an empty list as their [properties]*)

val add_to_hand : player -> Deck.card -> player
(** [add_to_hand player card] is a player with an updated [hand] thats has card*)

val remove_from_hand : player -> Deck.card -> player
(** [remove_from_hand player card] is a player with an updated [hand] that has
    card removed*)

val bank_money : player -> int -> player
(** [bank_money player amount] returns a new player with the [amount] added to
    their [bank] *)

val add_property : player -> string * string -> player
(** [add_property player property] returns a new player with the given
    [property] added to their [properties] *)

val get_name : player -> string
(** [get_name player] returns the name of the player*)

val get_property_sets : player -> int
(** [get_property_sets player] returns the number of full property sets the
    player has *)

val get_hand : player -> Deck.card list
(** [get_hand player] returns the list of cards currently in the player's hand *)
