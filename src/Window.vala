using ThetisSkinMaker.Utils;

namespace ThetisSkinMaker {

[GtkTemplate(ui="/io/github/ydalton/ThetisSkinMaker/ui/window.ui")]
public class Window : Gtk.ApplicationWindow
{
    [GtkChild]
    private unowned Gtk.Entry name_entry;
    [GtkChild]
    private unowned Gtk.FileChooserButton chooser;
    [GtkChild]
    private unowned Gtk.ComboBox dropdown;
    [GtkChild]
    private unowned Gtk.Image preview;
    private ISkinManager _skin_manager;
    private ISkinManager skin_manager {
        get {
            if(_skin_manager == null)
                _skin_manager = SkinManagerFactory.get_default();
            return _skin_manager;
        }
    }

    private bool is_saved = false;

    /* FIXME: hardcoded */
    private float image_width = 450.0f;

    private Gdk.Pixbuf bg_image;

    private ActionEntry win_entries[4] = {
        { "about", activate_about },
        { "save", activate_save },
        { "show-tips", activate_show_tips },
        { "new", activate_new },
    };

    private string[] supported_image_types = {
        "png",
        "jpeg",
        "jpg",
    };

    private List<string> _skins;
    private List<string> skins {
        get {
            if(_skins == null)
                _skins = skin_manager.get_skins();
            return _skins;
        }
    }

    construct
    {
        this.add_file_filters();
        if(skins.length() == 0) {
            show_error_box("Skins Not Found",
                           "Could not open the Thetis skin folder, is Thetis installed?");
            Process.exit(-1);
        }

        dropdown.model = build_model_from_list(skins);

        /* why? */
        var renderer = new Gtk.CellRendererText();
        dropdown.pack_start(renderer, true);
        dropdown.add_attribute(renderer, "text", 0);

        this.add_action_entries(win_entries, this);
    }

    public Window(Gtk.Application application)
    {
        Object(application: application);
    }

    private void activate_about()
    {
        Gtk.show_about_dialog(this,
                              program_name: "ThetisSkinMaker",
                              copyright: "Copyright 2024 Yussef Dalton",
                              comments: "With special thanks to John Dalton ON8EI");
    }

    [GtkCallback]
    private void on_selection_changed_cb()
    {
        var image_name = this.chooser.get_filename();
        if(image_name == null)
            return;

        bg_image = null;

        try {
            bg_image = new Gdk.Pixbuf.from_file(image_name);
        } catch(Error e) {
            show_error_box("Error Loading Image",
                           "The file you provided is not a valid image file or there was an error while loading the file.\n\n"
                           + "Specific error: " + e.message);
            preview.visible = false;
            preview.pixbuf = null;
            return;
        }

        assert(bg_image.width != 0);
        float ratio = image_width/bg_image.width;
        float new_height = bg_image.height * ratio;

         /* Scale the image so that it doesn't expand the window absurdly */
        preview.pixbuf = bg_image.scale_simple((int) image_width,
                                               (int) new_height,
                                               Gdk.InterpType.NEAREST);
        preview.visible = true;
    }

    private void activate_show_tips()
    {
        show_info_box("Tips",
                      "Let me tell you something...\n\n"
                      + "If you want to add text to the image, you need to do that beforehand: this program doesn't do that (yet).");
    }

    private void activate_save()
    {
        var skin_name = name_entry.text;
        if(skin_name == "") {
            show_error_box("Name Required",
                           "Please provide a name for your skin.");
            return;
        }

        if(bg_image == null) {
            show_error_box("Image Required",
                           "Please provide an image for your skin.");
            return;
        }

        /* normally this should never fail */
        assert(FileUtils.test(this.chooser.get_filename(), FileTest.EXISTS));

        string base_skin = get_selected_item(dropdown);

        try {
            skin_manager.save_skin(skin_name, bg_image, base_skin);
        } catch (Error e) {
            show_error_box("Error", "Error! " + e.message);
            return;
        }

        show_info_box("Skin Saved",
                      "Skin successfully saved! Please restart Thetis if it is already open.");
        
        is_saved = true;
    }

    private void activate_new()
    {
        if(!is_saved) {
            int ret = show_yes_no_box("Confirm Discard?",
                                                     "Are you sure you want to discard this skin?");
            switch(ret) {
            case MessageBoxResponse.IDYES:
                break;
            case MessageBoxResponse.IDNO:
            case MessageBoxResponse.IDCANCEL:
                return;
            }
        }

        this.bg_image = null;
        this.preview.pixbuf = null;
        this.chooser.unselect_all();
        this.name_entry.text = "";

        is_saved = false;
    }

    private void add_file_filters()
    {
        var image_filter = new Gtk.FileFilter();

        foreach(var image_type in this.supported_image_types) {
            image_filter.add_pattern(@"*.$image_type");
        }

        image_filter.set_name("All image files");

        this.chooser.add_filter(image_filter);

        /* for "All files" */
        var all_filter = new Gtk.FileFilter();
        all_filter.add_pattern("*");
        all_filter.set_name("All files");

        this.chooser.add_filter(all_filter);
    }

    private string? get_selected_item(Gtk.ComboBox box)
    {
        string selected_item;
        Gtk.TreeIter iter;

        /* empty */
        if(!box.get_active_iter(out iter))
            return null;

        var model = dropdown.model;
        model.get(iter, 0, out selected_item);
        return selected_item;
    }

    private Gtk.TreeModel build_model_from_list(List<string> list)
    {
        Gtk.TreeIter iter;

        var store = new Gtk.ListStore(1, Type.STRING);

        foreach(var list_item in list) {
            store.append(out iter);
            store.set(iter, 0, list_item, -1);
            message("%s", list_item);
        }

        return store;
    }
}

} /* namespace ThetisSkinMaker */