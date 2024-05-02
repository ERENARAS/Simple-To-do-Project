// importlar

import Map "mo:base/HashMap";
import Hash "mo:base/Hash"; // tur belirleme
import Nat "mo:base/Nat"; // integer belirleme unsigned natural integer sayiler
import Iter "mo:base/Iter";
import Text "mo:base/Text";


// smart contract = > canister(icp)

actor Assistant { // akilli sozlesme istersen ad belirleme
  type ToDo = {
    description: Text;
    completed:Bool;
  };

  func natHash(n:Nat) :Hash.Hash{ // private fonksiyon
    Text.hash(Nat.toText(n))
  };


  var todos = Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash);     // mutuble
  var nextId : Nat = 0;


  // func => private
  // public query func => sorgulama
  // puvlic fun => update => guncelleme

  public query func getTodos(): async [ToDo]{
    Iter.toArray(todos.vals());
  };


  public func addTodo(description : Text) : async Nat{
    let id = nextId;
    todos.put(id,{description = description; completed = false});
    nextId+=1;
    return id;
  };

  public func completeTodo(id:Nat): async(){
    ignore do ? {
      let description = todos.get(id)!.description;
      todos.put(id, {description ; completed = true});
    } // ne olursa olsun islemi yok saymak  
  };

  public query func showTodos():async Text{
    var output :Text = "\n_______TO-DOs________";
    for(todo : ToDo in todos.vals()){
      output #= "\n" # todo.description;
      if(todo.completed){
        output #=" !";
      };
    };
    output #"\n"
  };

  public func clearCompleted() : async(){
    todos := Map.mapFilter<Nat, ToDo, ToDo>(todos, Nat.equal, natHash, 
      func(_ , todo){if (todo.completed) null else ? todo});
  };









};















