namespace ThetisSkinMaker.Utils
{

public class SkinManagerFactory
{
    private static ISkinManager _instance;

    public static ISkinManager get_default()
    {
        if(_instance == null) {
            #if _WIN32
            _instance = new ThetisSkinManager();
            #else
            _instance = new NoopSkinManager();
            #endif
        }
        return _instance;
    }
}

} /* namespace ThetisSkinMaker.Utils */