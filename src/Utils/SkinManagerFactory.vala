namespace ThetisSkinMaker.Utils
{

public class SkinManagerFactory
{
    private static ISkinManager _instance;

    public static ISkinManager get_default()
    {
        if(_instance == null) {
            /* FIXME: preprocessing directives do not work. */
            _instance = new ThetisSkinManager();
        }
        return _instance;
    }
}

} /* namespace ThetisSkinMaker.Utils */