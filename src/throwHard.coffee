module.exports = (err) ->
  if typeof err is "string" or err instanceof String
    err = new Error err
  unless err instanceof Error
    err = new Error "Non-string, non-Error error."
  try
    throw new Error err
  catch error
    setImmediate ->
      console.error ""
      console.error error.stack
      process.exit 1
      throw error
  throw err