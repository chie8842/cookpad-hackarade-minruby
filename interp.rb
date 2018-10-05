require "minruby"

# An implementation of the evaluator
def evaluate(exp, env, function_definitions)
  # p(exp)
  # p env
  # exp: A current node of AST
  # env: An environment (explained later)

  case exp[0]

#
## Problem 1: Arithmetics
#

  when "lit"
    exp[1] # return the immediate value as is

  when "+"
    evaluate(exp[1], env, function_definitions) + evaluate(exp[2], env, function_definitions)

  when "-"
    # Subtraction.  Please fill in.
    # Use the code above for addition as a reference.
    # (Almost just copy-and-paste.  This is an exercise.)
    evaluate(exp[1], env, function_definitions) - evaluate(exp[2], env, function_definitions)

#    raise(NotImplementedError) # Problem 1
  when "*"
    evaluate(exp[1], env, function_definitions) * evaluate(exp[2], env, function_definitions)

  when "%"
    evaluate(exp[1], env, function_definitions) % evaluate(exp[2], env, function_definitions)

  when "/"
    evaluate(exp[1], env, function_definitions) / evaluate(exp[2], env, function_definitions)

  when ">"
    evaluate(exp[1], env, function_definitions) > evaluate(exp[2], env, function_definitions)

  when "<"
    evaluate(exp[1], env, function_definitions) < evaluate(exp[2], env, function_definitions)

  when "=="
    evaluate(exp[1], env, function_definitions) == evaluate(exp[2], env, function_definitions)

#    raise(NotImplementedError) # Problem 1
  # ... Implement other operators that you need

  
#
## Problem 2: Statements and variables
#

  when "stmts"
    i = 1
    while exp[i]
      x = evaluate(exp[i], env, function_definitions)
      i = i + 1
    end
    x
#    (1..exp.count-1).each{|num|
#      evaluate(exp[num], env)
#    }
    # Statements: sequential evaluation of one or more expressions.
    #
    # Advice 1: Insert `pp(exp)` and observe the AST first.
    # Advice 2: Apply `evaluate` to each child of this node.
#    raise(NotImplementedError) # Problem 2

  # The second argument of this method, `env`, is an "environement" that
  # keeps track of the values stored to variables.
  # It is a Hash object whose key is a variable name and whose value is a
  # value stored to the corresponded variable.

  when "var_ref"
    #p exp
    #p env
    name2 = exp[1]
    #p "------"
    #p name2
    env[name2]

    # Variable reference: lookup the value corresponded to the variable
    #
    # Advice: env[???]
    # raise(NotImplementedError) # Problem 2

  when "var_assign"
      name = exp[1]
      value = evaluate(exp[2], env, function_definitions)
      env[name] = value

    # Variable assignment: store (or overwrite) the value to the environment
    #
    # Advice: env[???] = ???
    # raise(NotImplementedError) # Problem 2

#
## Problem 3: Branchs and loops
#

  when "if"
    # Branch.  It evaluates either exp[2] or exp[3] depending upon the
    # evaluation result of exp[1],
    #
    # Advice:
    #   if ???
    #     ???
    #   else
    #     ???
    #   end
    # raise(NotImplementedError) # Problem 3
    if evaluate(exp[1], env, function_definitions) == true
      evaluate(exp[2], env, function_definitions)
    else
      evaluate(exp[3], env, function_definitions)
    end

  when "while"
    # Loop.
    #raise(NotImplementedError) # Problem 3
    while evaluate(exp[1], env, function_definitions) do
      evaluate(exp[2], env, function_definitions)
    end


#
## Problem 4: Function calls
#

  when "func_call"
    # Lookup the function definition by the given function name.
    func = function_definitions[exp[1]]

    if func == nil
      # We couldn't find a user-defined function definition;
      # it should be a builtin function.
      # Dispatch upon the given function name, and do paticular tasks.
      case exp[1]
      when "p"
        # MinRuby's `p` method is implemented by Ruby's `p` method.
        p(evaluate(exp[2], env, function_definitions))
      # ... Problem 4
      when "Integer"
        Integer(evaluate(exp[2], env, function_definitions))

      when "fizzbuzz"
        if evaluate(exp[2], env, function_definitions) % 15 == 0
          "FizzBuzz"
        elsif evaluate(exp[2], env, function_definitions) % 3 == 0
          "Fizz"
        elsif evaluate(exp[2], env, function_definitions) % 5 == 0
          "Buzz"
        else
          evaluate(exp[2], env, function_definitions)
        end

      when "require"
        require evaluate(exp[2], env, function_definitions)

      when "minruby_parse"
          minruby_parse(evaluate(exp[2], env, function_definitions))

      when "minruby_load"
          minruby_load()

      else
        raise("unknown builtin function")
      end
    else

#
## Problem 5: Function definition
#

      # (You may want to implement "func_def" first.)
      #
      # Here, we could find a user-defined function definition.
      # The variable `func` should be a value that was stored at "func_def":
      # parameter list and AST of function body.
      #
      # Function calls evaluates the AST of function body within a new scope.
      # You know, you cannot access a varible out of function.
      # Therefore, you need to create a new environment, and evaluate the
      # function body under the environment.
      #
      # Note, you can access formal parameters (*1) in function body.
      # So, the new environment must be initialized with each parameter.
      #
      # (*1) formal parameter: a variable as found in the function definition.
      # For example, `a`, `b`, and `c` are the formal parameters of
      # `def foo(a, b, c)`.
      #if $function_definitions.key?(exp[1])
      method_info = function_definitions[exp[1]]
      env_new = {}
      i = 0
      while method_info[2][i]
        env_new[method_info[2][i]] = evaluate(exp[i+2], env, function_definitions)
        i = i + 1
      end

      evaluate(method_info[3], env_new, function_definitions)
      # raise(NotImplementedError) # Problem 5
    end

  when "func_def"
    # Function definition.
    #
    # Add a new function definition to function definition list.
    # The AST of "func_def" contains function name, parameter list, and the
    # child AST of function body.
    # All you need is store them into $function_definitions.
    #
    # Advice: $function_definitions[???] = ???

    # raise(NotImplementedError) # Problem 5
    function_definitions[exp[1]] = exp

#
## Problem 6: Arrays and Hashes
#

  # You don't need advices anymore, do you?
  when "ary_new"
    array = []
    i = 1
    while exp[i]
      array[i-1] = evaluate(exp[i], env, function_definitions)
      i = i + 1
    end
    array

    #exp[1..-1].each {|x| array.append(evaluate(x, env))}
    #array
    # raise(NotImplementedError) # Problem 6

  when "ary_ref"
    evaluate(exp[1], env, function_definitions)[evaluate(exp[2], env, function_definitions)]
    # raise(NotImplementedError) # Problem 6

  when "ary_assign"
    evaluate(exp[1], env, function_definitions)[evaluate(exp[2], env, function_definitions)] = evaluate(exp[3], env, function_definitions)
    # raise(NotImplementedError) # Problem 6

  when "hash_new"
    i = 1
    hash = {}
    while exp[i]
      hash[evaluate(exp[i], env, function_definitions)] = evaluate(exp[i+1], env, function_definitions)
      i = i + 2
    end
    hash

    # raise(NotImplementedError) # Problem 6

  else
    p("error")
    pp(exp)
    raise("unknown node")
  end
end


 function_definitions = {}
env = {}

# `minruby_load()` == `File.read(ARGV.shift)`
# `minruby_parse(str)` parses a program text given, and returns its AST
x = minruby_parse(minruby_load())
# p(x)
evaluate(x, env, function_definitions)
