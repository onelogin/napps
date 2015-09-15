package onelogin.com.signal;

import java.io.Serializable;

/**
 * Created by troysimon on 10/9/14.
 */
public class SectionItem
        implements Serializable {

    private String name;


    public SectionItem(String name) {
        super();
        this.setName(name);
    }



    public void setName(String name) {
        this.name = name;
    }
}
