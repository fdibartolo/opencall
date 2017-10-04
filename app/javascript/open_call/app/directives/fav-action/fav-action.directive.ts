import { Directive, HostListener, HostBinding, Input, OnChanges } from '@angular/core';
import { SessionsComponent } from '../../components/sessions/sessions.component';

@Directive({
  selector: '[favAction]'
})
export class FavActionDirective implements OnChanges {

  constructor(private component: SessionsComponent) { }

  @Input('favAction') isFaved:boolean;
  @Input() sessionId:string;

  @HostBinding('class.fa') f = true
  @HostBinding('class.text-warning') t = true

  @HostBinding('class.fa-star') filled: boolean
  @HostBinding('class.fa-star-o') outline: boolean
  @HostBinding('class.animated') animated: boolean
  @HostBinding('class.tada') tada: boolean

  @HostListener('click') onClick() { this.component.fav(this.sessionId) }

  ngOnChanges(changes: any) {
    this.filled = changes.isFaved.currentValue
    this.outline = !this.isFaved

    if (this.filled) {
      this.animated = true
      this.tada = true
      setTimeout(() => {  
        this.animated = false
        this.tada = false
      }, 1000);
    }
  }
}
