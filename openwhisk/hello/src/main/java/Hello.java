import com.google.gson.JsonObject;

public class Hello {
    public static JsonObject main(JsonObject args){
        String name;

        try {
            name = args.getAsJsonPrimitive("name").getAsString();
        } catch(Exception e) {
            name = "world";
        }

        JsonObject response = new JsonObject();
        response.addProperty("msg", "Hello " + name + "!");
        return response;
    }
}