open OUnit2
open Project3110.Deck

(*************** Helpers for Testing Deck.mli *********************************)
let test_deck = Project3110.Deck.shuffle_deck (Project3110.Deck.init_deck ())

let rec draw_card deck int =
  match int with
  | 0 -> deck
  | _ -> draw_card (snd (Project3110.Deck.draw_card deck)) (int - 1)

let new_deck = draw_card test_deck 7

(*************** Helpers for Testing Player.mli *******************************)
let player1_init = Project3110.Player.init_player "player1"

let rec add_hand player card_lst =
  match card_lst with
  | [] -> player
  | h :: t ->
      let updated_player = Project3110.Player.add_to_hand player h in
      add_hand updated_player t

let rec add_property player deck =
  match deck with
  | [] -> player
  | card :: rest ->
      let updated_player = Project3110.Player.add_property player card in
      add_property updated_player rest

let player1 =
  add_property player1_init
    [
      ("Light Blue", "Oriental Avenue");
      ("Light Blue", "Vermont Avenue");
      ("Light Blue", "Connecticut Avenue");
      ("Orange", "St. James Place");
      ("Orange", "Tennessee Avenue");
    ]

let player1 =
  add_hand player1
    [
      Property ("Railroad", "Reading Railroad");
      Property ("Railroad", "Pennsylvania Railroad");
      Money 4;
      Money 1;
      Action "Debt Collector";
    ]

let player1_remove_sets =
  Project3110.Player.remove_property player1 ("Light Blue", "Connecticut Avenue")

(* bank_money *)
let player1 = Project3110.Player.remove_from_bank player1 8
let player2 = Project3110.Player.bank_money player1 6

(************************* Beginning of Test Suite ****************************)
let create_test test_name input output =
  test_name >:: fun _ -> assert_equal input output

let tests =
  "test suite"
  >::: [
         (******************** Deck.mli tests ********************************)
         ("Deck test" >:: fun _ -> assert_equal (List.length test_deck) 89);
         create_test "Testing - draw_card" (List.length new_deck) 82;
         (******************** init_player tests *****************************)
         (* 1. Player name is player1 *)
         create_test "Testing Player - init name"
           (Project3110.Player.get_name player1_init)
           "player1";
         (* 2. Player is initialized with 0 properties *)
         create_test "Testing Player - init properties"
           (Project3110.Player.get_properties player1_init)
           [];
         create_test "Testing Player - init bank: 0"
           (Project3110.Player.get_bank player1_init)
           0;
         create_test "Testing Player - init deck: empty list"
           (Project3110.Player.get_hand player1_init)
           [];
         (********************* add/remove_from_hand tests *******************)
         create_test "Testing Player - add cards to hand "
           (List.rev (Project3110.Player.get_hand player1))
           [
             Property ("Railroad", "Reading Railroad");
             Property ("Railroad", "Pennsylvania Railroad");
             Money 4;
             Money 1;
             Action "Debt Collector";
           ];
         create_test "Testing Player - remove card from empty hand"
           (Project3110.Player.remove_from_hand player1_init (Money 5))
           player1_init;
         create_test "Testing Player - Remove card from hand that isn't there"
           (List.rev
              (Project3110.Player.get_hand
                 (Project3110.Player.remove_from_hand player1 (Money 5))))
           [
             Property ("Railroad", "Reading Railroad");
             Property ("Railroad", "Pennsylvania Railroad");
             Money 4;
             Money 1;
             Action "Debt Collector";
           ];
         create_test "Testing Player - removing a card from a player"
           (List.rev
              (Project3110.Player.get_hand
                 (Project3110.Player.remove_from_hand player1 (Money 4))))
           [
             Property ("Railroad", "Reading Railroad");
             Property ("Railroad", "Pennsylvania Railroad");
             Money 1;
             Action "Debt Collector";
           ];
         (******** add/remove properites/ get_property_sets test *************)
         create_test "Testing Player - 1 full set in properties"
           (Project3110.Player.get_property_sets player1)
           1;
         (***************** bank_money/remove_from_bank tests *****************)
         create_test "Testing Player - Removing money from 0 bank "
           (Project3110.Player.get_bank player1)
           0;
         create_test "Testing Player - Adding money to non-zero bank"
           (Project3110.Player.get_bank
              (Project3110.Player.bank_money player2 5))
           11;
         create_test "Testing Player - Removing from non-zero bank"
           (Project3110.Player.get_bank
              (Project3110.Player.remove_from_bank player2 4))
           2;
         create_test "Testing - Drawing multiple cards from deck "
           (List.length new_deck) 82;
       ]

let _ = run_test_tt_main tests
