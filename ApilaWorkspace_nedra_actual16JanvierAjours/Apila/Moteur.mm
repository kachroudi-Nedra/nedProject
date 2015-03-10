//
//  ouuuuff.h
//  AutomateV4
//
//  Created by Nedra Kachroudi on 12/11/2014.
//  Copyright (c) 2014 Nedra Kachroudi. All rights reserved.
//


#include <stdio.h>
#include <vector>
#include <map>
#include <string>
#include <iostream>

using namespace std;
#include "Moteur.h"


class changes {
public:
    state next_state;
    vector <action> todos;
};

class global_state {
public:
    state current_state;
    state next_state;
    event current_event;
    action todo;
    void init(state cs,state ns,event ce,action t){
        current_state=cs;
        next_state=ns;
        current_event=ce;
        todo=t;
    }
};
class motor {
    map < state, map < event, changes > > transitions;
    state current_state;
    event current_event;
    size_t current_todo;
public:
     void init(  map < state, map < event, changes > > &t,state first_state=d_voit_proche_usageCourt_gpsS);
    state next(event new_event);
    state next_todo(event new_event, vector <action> &todos);
    action todo();
    global_state todo_with_info();
    string getState(state new_state);

   
};

void motor::init(  map < state, map < event, changes > > &t,state first_state){
    transitions=t;
    current_state=first_state;
    current_event=E_NO_EVENT;
    current_todo=0;
}
state motor::next(event new_event){
    current_event=new_event;
    current_todo=0;
    return transitions[current_state][new_event].next_state;
}
state motor::next_todo(event new_event, vector <action> &todos){
    current_event=new_event;
    todos=transitions[current_state][new_event].todos;
    return current_state=transitions[current_state][new_event].next_state;
}
action motor::todo(){
    if(current_todo<transitions[current_state][current_event].todos.size()){
        return transitions[current_state][current_event].todos[current_todo++];
    }else {
        current_state=transitions[current_state][current_event].next_state;
        current_todo=0;
        return A_DONE;
    }
}
global_state motor::todo_with_info(){
    global_state tmp;
    if(current_todo<transitions[current_state][current_event].todos.size()){
        state cs;state ns;event ce;action t;
        //    return tmp.init(
        cs=current_state;
        ns=transitions[current_state][current_event].next_state;
        ce=current_event;
        t=transitions[current_state][current_event].todos[current_todo++];
		      //);
        tmp.init(cs,ns,ce,t);
    }    else {
        tmp.init(current_state,
                 transitions[current_state][current_event].next_state,
                 current_event,
                 A_DONE);
        current_state=transitions[current_state][current_event].next_state;
        current_todo=0;
    }
    return tmp;
}
#include "Moteur_gbl.h"



void init_motor(enum state initial){
    mymotor.init(transitions_apila,initial);
    
}
enum state next_motor( enum event new_event){
   
    return mymotor.next(new_event);
    
}
enum action todo_motor(){
    return mymotor.todo();
}


